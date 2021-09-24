# frozen_string_literal: true

#  Copyright (c) 2021, Die Mitte Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Export::Pdf::Messages::LetterWithInvoice
  class DonationConfirmation < Export::Pdf::Messages::Letter::Section
    ONE_YEAR = 1.year

    def initialize(pdf, letter, recipient, options)
      super(pdf, letter, options)
      pdf.start_new_page
      @recipient = recipient
      @letter = letter
    end

    def render
      header
      donation_text = stamped(:donation_confirmation_text) { donation_confirmation_text }
      text([donation_text, last_year_donation_amount])
    end

    private

    def header
      stamped(:donation_confirmation_header) { donation_confirmation_header }
      pdf.move_down 8
      stamped(:donation_confirmation_salutation) { salutation_text }
      stamped(:donation_confirmation_content) { donation_confirmation_content }

      title
    end

    def title
      stamped(:donation_confirmation_title) { donation_confirmation_title }
      pdf.stroke_horizontal_rule
      pdf.move_down 4
    end

    def salutation_text
      text Salutation.new(@recipient, letter.salutation).value + break_line
    end

    def donation_confirmation_content
      text I18n.t('messages.export.section.donation_confirmation.acknowledgement') + break_line
    end

    def donation_confirmation_header
      layer_name = @letter.group.layer_group.name
      layer_name[0] = layer_name[0].downcase
      text I18n.t('messages.export.section.donation_confirmation.header', organisation: layer_name),
           style: :bold,
           size: 14
    end

    def donation_confirmation_title
      text I18n.t('messages.export.section.donation_confirmation.title', year: ONE_YEAR.ago.year),
           style: :bold
    end

    def donation_confirmation_text
      "\n " +
      I18n.t('messages.export.section.donation_confirmation.received_from',
             year: ONE_YEAR.ago.year) +
      break_line +
      recipient_address +
      break_line +
      I18n.t('messages.export.section.donation_confirmation.received_amount') +
      break_line
    end

    def last_year_donation_amount
      currency = letter.invoice.currency

      donation_amount = Donation.new.
                                in_last(ONE_YEAR).
                                in_layer(letter.group).
                                of_person(@recipient).
                                previous_amount.
                                to_s

      "#{currency} #{donation_amount}"
    end

    def recipient_address
      name = "#{@recipient.first_name}, #{@recipient.last_name} \n"
      name + "#{@recipient.address}, #{@recipient.zip_code} #{@recipient.town}"
    end

    def break_line
      "\n\n"
    end
  end
end
