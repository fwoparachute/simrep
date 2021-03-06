ActiveAdmin.register NpcShift do
  menu false

  includes character_event: :character

  batch_action :close_out_shifts do |ids|
    batch_action_collection.find(ids).each do |ns|
      ns.close_shift(ns.closing || Time.now)
    end
    redirect_to collection_path, notice: "#{[ids]} were closed out."
  end

  index do
    selectable_column
    column :id do |ns|
      link_to ns.id, admin_npc_shift_path(ns)
    end
    column "Character", :character_event_id do |ns|
      link_to ns.character.name, admin_character_path(ns.character)
    end
    column :opening
    column :closing
    column :dirty
    column :updated_at
    column "Paid?", :bank_transaction_id do |ns|
      ns.bank_transaction.present? ? link_to("Yes", admin_bank_account_path(ns.bank_transaction.to_account_id)) : "No"
    end
    actions
  end

  begin
    filter :character_event_event_weekend, as: :select, collection: proc { Event.all.order(weekend: :desc).pluck(:weekend) }
    filter :opening
    filter :closing
    filter :dirty
  rescue
    p "msg"
  end

  show do
    attributes_table do
      row :id
      row :character
      row :event
      row :opening
      row :closing
      row :dirty
      row :created_at
      row :updated_at
      row :bank_transaction
    end
  end

  form do |f|
    f.inputs do
      input :character_event, as: :select, collection: CharacterEvent.order_for_select
      input :opening, as: :date_time_picker, datepicker_options: { step: 15 }
      input :closing, as: :date_time_picker, datepicker_options: { step: 15 }
      input :dirty
    end

    f.actions
  end
end
