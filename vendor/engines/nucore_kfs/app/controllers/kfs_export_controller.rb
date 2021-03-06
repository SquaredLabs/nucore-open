class KfsExportController < ApplicationController
  def show
    @journal = Journal.find(params[:id])
    @journal.journal_rows.each do |journal_row|
      od = journal_row.order_detail
      next unless journal_row.order_detail
      prod = journal_row.order_detail.product
      aan_out = od.account.account_number
      fan_out = prod.facility_account.account_number

      flash[:error] = "for id #{od.id}: order account not a kfs account: #{aan_out}" unless aan_out.match(/^KFS-(?<acct_num>\d{0,7})-(?<obj_code>\d{4})$/)
      flash[:error] = "for id #{od.id}: recharge account not a kfs account: #{fan_out}" unless fan_out.match(/^KFS-(?<acct_num>\d{0,7})-(?<obj_code>\d{4})$/)
      if flash[:error]
        redirect_to facility_journals_path(current_facility)
        return
      end
    end
    render action: "show.#{params[:format]}.erb", layout: false, content_type: "application/kfs-collector"
  end
end
