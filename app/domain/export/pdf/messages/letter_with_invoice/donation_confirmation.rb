# frozen_string_literal: true

#  Copyright (c) 2021, Die Mitte Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Export::Pdf::Messages::LetterWithInvoice
  class DonationConfirmation < Export::Pdf::Messages::Letter::Section
    def initialize(pdf, letter, recipient, options)
      super(pdf, letter, options)
      @recipient = recipient
    end

    def render
      donation_text = stamped(:donation_confirmation_text) { donation_confirmation_text }
      text([donation_text, last_year_donation_amount])
    end

    private

    def donation_confirmation_text
      "\n " + I18n.t('messages.export.section.donation_confirmation')
    end

    def last_year_donation_amount
      currency = letter.invoice.currency

      donation_amount = Donation.new.
                                in_last(1.year).
                                in_layer(letter.group).
                                of_person(@recipient).
                                previous_amount.
                                to_s

      "#{donation_amount} #{currency}"
    end
  end
end
