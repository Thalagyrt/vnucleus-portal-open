module Features
  module ChosenHelpers
    def select_chosen(item_text, options)
      field = find_field(options[:from], visible: false)
      option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
      page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
      option_value = page.evaluate_script("value")
      page.execute_script("$('##{field[:id]}').val(#{option_value})")
      page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
    end
  end
end