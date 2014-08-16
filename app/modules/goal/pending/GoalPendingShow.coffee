@App.module "GoalTrack.Pending", (Pending, App, Backbone, Marionette, $, _) ->

	Controller =
		pending: (region) ->
			pendingGoals = App.request("goal:entities:my:pending")
			pendingGoals.on("sync", (collections) ->
				if (collections.length == 0)
					console.log("Collection #{JSON.stringify(collections)}")
					App.request "goal:new:my", region
				else
					pendingGoals.forEach( (goal) ->
						goalLayout = new GoalLayout
						goalLayout.on "show", () ->
							goalView = new Goal
								model: goal
							goalLayout.detailsRegion.show goalView
							App.request("goal:status:new", goal, goalLayout.statusRegion)
						region.show goalLayout
					)
			)

	class Goal extends Marionette.ItemView
		template: require './templates/goal'
		onShow: () ->
			$('#dueDate').FlipClock((@model.get("dueDate") - new Date().getTime()) / 1000, {
				clockFace: 'DailyCounter',
				countdown: true,
				showSeconds: false
			});

	class GoalLayout extends  Marionette.LayoutView
		template: require './templates/layout'
		regions:
			detailsRegion : '#detailsRegion'
			statusRegion  : '#statusRegion'


	class Goals extends Marionette.CompositeView
		template: require './templates/goals'
		childView: Goal
		childViewContainer: 'div'

	App.reqres.setHandler "goal:pending:my", (region) -> Controller.pending(region)

