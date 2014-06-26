# encoding: utf-8
module WatirNokogiri
  class Radio < Input

    #
    # Selects this radio button.
    #

    def set
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    #
    # Is this radio set?
    #
    # @return [Boolean]
    #

    def set?
      assert_exists
      !@element.get_attribute('checked').nil?
    end

  end # Radio

  module Container
    def radio(*args)
      Radio.new(self, extract_selector(args).merge(:tag_name => "input", :type => "radio"))
    end

    def radios(*args)
      RadioCollection.new(self, extract_selector(args).merge(:tag_name => "input", :type => "radio" ))
    end
  end # Container

  class RadioCollection < InputCollection
    private

    def element_class
      Radio
    end
  end # RadioCollection
end # WatirNokogiri
