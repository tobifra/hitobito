# frozen_string_literal: true

#  Copyright (c) 2021, Die Mitte Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Export::Pdf::Messages::LetterWithInvoice
  class DonationConfirmation < Export::Pdf::Messages::Letter::Section
    def initialize(pdf, letter, recipient, options)
      super(pdf, letter, options)
      pdf.start_new_page
      @recipient = recipient
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
      text "Wir danken Ihnen für Ihr Vertrauen und Ihr geschätztes Engagement!" + break_line
    end

    def donation_confirmation_header
      text "Spenden an die CVP Schweiz", style: :bold, size: 14
    end

    def donation_confirmation_title
      text "Spendenbestätigung 2020", style: :bold
    end

    def donation_confirmation_text
      "\n " +
      "2020 haben wir von" +
      break_line +
      recipient_address +
      break_line +
      "Spenden erhalten in der Höhe von" +
      break_line
    end

    def last_year_donation_amount
      currency = letter.invoice.currency

      donation_amount = Donation.new.
                                in_last(1.year).
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
