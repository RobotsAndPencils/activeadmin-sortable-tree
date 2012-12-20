module ActiveAdmin
  module Views

    # = Index as a Sortable Tree
    class IndexAsTree < ActiveAdmin::Component
      def build(page_presenter, collection)
        @page_presenter = page_presenter
        @collection = collection

        # Call the block passed in. This will set the
        # title and body methods
        instance_eval &page_presenter.block if page_presenter.block

        add_class "index"
        build_list
      end

      # Setter method for the configuration of the label
      def label(method = nil, &block)
        if block_given? || method
          @label = block_given? ? block : method
        end
        @label
      end

      # Adds links to View, Edit and Delete
      def default_actions
        @default_actions = true
      end


      protected

      def build_list
        resource_selection_toggle_panel if active_admin_config.batch_actions.any?
        ol :class => "index_tree", :"data-sortable" => "tree" do
          collection.each do |item|
            build_item(item)
          end
        end
      end

      def build_item(item)
        li :class => cycle("odd", "even", :name => "list_class"), :id => "#{active_admin_config.resource_name}_#{item.id}".downcase do
          div :class => "tr" do
            div :class => "td" do
              resource_selection_cell(item) if active_admin_config.batch_actions.any?
            end
            h3 :class => "td" do
              call_method_or_proc_on(item, @label)
            end
            div :class => "td" do
              build_default_actions(item) if @default_actions
            end
          end
        end
      end

      def build_default_actions(resource)
        links = ''.html_safe
        if controller.action_methods.include?('show')
          links << link_to(I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link")
        end
        if controller.action_methods.include?('edit')
          links << link_to(I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link")
        end
        if controller.action_methods.include?('destroy')
          links << link_to(I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link")
        end
        links
      end

    end
  end
end
