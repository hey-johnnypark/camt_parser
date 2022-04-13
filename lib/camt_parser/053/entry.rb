module CamtParser
  module Format053
    class Entry
      def initialize(xml_data)
        @xml_data = xml_data
        @amount = @xml_data.xpath('Amt/text()').text
      end

      def amount
        CamtParser::Misc.to_amount(@amount)
      end

      def amount_in_cents
        CamtParser::Misc.to_amount_in_cents(@amount)
      end

      def currency
        @currency ||= @xml_data.xpath('Amt/@Ccy').text
      end

      def debit
        @debit ||= @xml_data.xpath('CdtDbtInd/text()').text.upcase == 'DBIT'
      end

      def value_date
        @value_date ||= Date.parse(@xml_data.xpath('ValDt/Dt/text()').text)
      end
      alias_method :date, :value_date

      def booking_date
        @booking_date ||= Date.parse(@xml_data.xpath('BookgDt/Dt/text()').text)
      end
      alias_method :entry_date, :booking_date

      def creditor
        @creditor ||= Creditor.new(@xml_data.xpath('NtryDtls'))
      end

      def credit?
        !debit
      end

      def debitor
        @debitor ||= Debitor.new(@xml_data.xpath('NtryDtls'))
      end

      def debit?
        debit
      end

      def sign
        credit? ? 1 : -1
      end

      def additional_information
        @additional_information ||= @xml_data.xpath('AddtlNtryInf/text()').text
      end
      alias_method :description, :additional_information

      def remittance_information
        @remittance_information ||= begin
          if (x = @xml_data.xpath('NtryDtls/TxDtls/RmtInf/Ustrd')).empty?
            nil
          else
            x.collect(&:content).join(' ')
          end
        end
      end
      alias_method :svwz, :remittance_information

      def name
        credit? ? debitor.name : creditor.name
      end

      def iban
        credit? ? debitor.iban : creditor.iban
      end

      def bic
        credit? ? debitor.bic : creditor.bic
      end

      def swift_code
        @swift_code ||= @xml_data.xpath('NtryDtls/TxDtls/BkTxCd/Prtry/Cd/text()').text.split('+')[0]
      end

      def reference
        @reference ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/InstrId/text()').text
      end

      def bank_reference
        @bank_reference ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/AcctSvcrRef/text()').text
      end

      def eref
        @eref ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/EndToEndId/text()').text
      end

      def mref
        @mref ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/MndtId/text()').text
      end

      def transaction_id
        @transaction_id ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/TxId/text()').text
      end

      def creditor_identifier
        @creditor_identifier ||= @xml_data.xpath('NtryDtls/TxDtls/RltdPties/Cdtr/Id/PrvtId/Othr/Id/text()').text
      end

      def information
        @information ||= @xml_data.xpath('NtryDtls/TxDtls/Refs/PmtInfId/text()').text
      end

      def msg_id
        @msg_id ||= @xml_data.xpath('NtryDtls/Btch/MsgId/text()').text
      end
    end
  end
end
