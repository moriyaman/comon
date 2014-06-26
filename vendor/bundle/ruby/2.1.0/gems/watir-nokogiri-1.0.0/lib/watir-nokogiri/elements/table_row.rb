module WatirNokogiri
  class TableRow < HTMLElement
    include CellContainer

    # @private
    attr_writer :locator_class

    #
    # Get the n'th cell (<th> or <td>) of this row
    #
    # @return Watir::TableCell
    #

    def [](idx)
      cell(:index, idx)
    end

    private

    def locator_class
      @locator_class || super
    end
  end # TableRow

  class TableRowCollection < ElementCollection
    attr_writer :locator_class

    def elements
      # we do this craziness since the xpath used will find direct child rows
      # before any rows inside thead/tbody/tfoot...
      elements = super

      if locator_class == ChildRowLocator and @parent.kind_of? Table
        # This sorting will not do anything since nokogiri does not know the rowIndex
        # BUG: https://github.com/jkotests/watir-nokogiri/issues/1
        elements = elements.sort_by { |row| row.get_attribute(:rowIndex).to_i }
      end

      elements
    end

    def locator_class
      @locator_class || super
    end
  end # TableRowCollection
end # Watir
