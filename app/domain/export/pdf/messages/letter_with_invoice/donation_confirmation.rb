# frozen_string_literal: true

class Export::Pdf::Messages::LetterWithInvoice
  class DonationConfirmation < Export::Pdf::Messages::Letter::Section
    def initialize(pdf, letter, recipient, options)
      super(pdf, letter, options)
      @recipient = recipient
    end

    def render
      stamped(:donation_confirmation_text) { donation_confirmation_text }
      last_year_donation_count
    end

    def donation_confirmation_text
      text "Folgender betrag wurde von Ihnen im letzten Jahr gespendet: "
    end

    def last_year_donation_count
      text Donation.new.in_last(1.year).in_layer(letter.group).of_person(@recipient).previous_amount.to_s
    end
  end
end
