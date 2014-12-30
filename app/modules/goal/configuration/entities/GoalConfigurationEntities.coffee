@App.module "GoalConfigurationApp.Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class GoalConfiguration extends Backbone.Model
		defaults:
			configurationKey: null
			privacyRule: null
			moveTimeRule: null
			totalTimeRule: null
		idAttribute: "configurationKey"

	class GoalConfigurations extends Backbone.Collection
		model: GoalConfiguration
		setSelected: (model) =>
			# Notifying of changed selection
			if (@selected?)
				@trigger("unselected:#{@selected.get('configurationKey')}", @selected)
				@trigger("unselected", @selected)

			# Specifying new selection
			@selected = model
			@trigger("selected:#{@selected.get('configurationKey')}", @selected)
			@trigger("selected", @selected)
		getSelected: () =>
			@selected

	API =
		getConfigurations: () ->
			configurations = new GoalConfigurations()
			configurations.url = App.Utils.toUrl('/configuration/my')
			configurations.once "sync", () ->
				configurations.setSelected(configurations.find((el) -> true))
			configurations.fetch()
			configurations

	App.reqres.setHandler 'goal:configuration:entities:all', () -> API.getConfigurations()
