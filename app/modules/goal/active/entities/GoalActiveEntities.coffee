@App.module "GoalActiveApp.Entities", (Entities, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	class GoalState extends Backbone.Model
		default:
			goalKey       : null
			player        : null
			configuration : null
			status        : null
			context       : null
		idAttribute: 'goalKey'

	class GoalStates extends Backbone.Collection
		model: GoalState

	API=
		myActive: () ->
			active = new GoalStates()
			active.url  = App.Utils.toUrl('/management/active/my')
			App.request("listener:subscribe:my", "goal:management", active, (body) -> new GoalState(body))
			active.fetch()
			active

	App.reqres.setHandler "goal:active:entities:my", () -> API.myActive()