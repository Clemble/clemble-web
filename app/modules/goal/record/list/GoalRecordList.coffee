@App.module "GoalRecordApp.List", (List, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	class GoalRecord extends Marionette.ItemView
		template: require './templates/goal_record'
		modelEvents:
			'change': 'render'

	class GoalRecords extends Marionette.CompositeView
		template : require './templates/goal_records'
		childView : GoalRecord
		childViewContainer : "div"

	Controller=
		listMy: (region) ->
			records = App.request("goal:record:entities:my")
			recordsView = new GoalRecords
				collection: records
			region.show recordsView

	App.reqres.setHandler "goal:record:list:my", (region) -> Controller.listMy(region)
