class CreateLedgerEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :ledger_entries do |t|
      t.integer :batch_sequence_number
      t.integer :document_number
      t.datetime :exported_on
      t.integer :kfs_status
      t.references :journal_row, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
