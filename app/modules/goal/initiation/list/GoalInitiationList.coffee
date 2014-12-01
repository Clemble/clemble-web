@App.module "GoalInitiationApp.List", (List, App, Backbone, Marionette, $, _) ->

	Controller =
		listMy: (region) ->
			initiations = App.request "goal:initiation:entities:my"
			initiationsView = new GoalInitiations
				collection: initiations
			region.show initiationsView
		listMyFriend: (region) ->
			initiations = App.request "goal:initiation:entities:my:friend"
			initiationsView = new GoalFriendInitiations
				collection: initiations
			region.show initiationsView

	class GoalInitiation extends Marionette.ItemView
		template: require './templates/goal_initiation'
		events:
			"click #confirm" : "confirm"
		confirm: () ->
			$.post(@model.url() + "/confirm", {})
		behaviors:
			Countdown: {}
		modelEvents:
			"change": "render"

	class GoalInitiations extends Marionette.CompositeView
		template: require './templates/goal_initiations'
		childView: GoalInitiation
		childViewContainer: "#content"
		emptyView: GoalInitiationsEmpty
		modelEvents:
			"sync"  : "render"
			"change": "render"

	class GoalInitiationsEmpty extends Marionette.ItemView
		template: require './templates/goal_initiation_empty'
		modelEvents:
			"change": "render"

	class GoalFriendInitiation extends Marionette.ItemView
		template: require './templates/goal_friend_initiation'
		events:
			'click #bet' : "bet"
		bet: () ->
			App.request "goal:active:action:bid:modal", @model.get('goalKey'), @model.get("configuration")['betRule']
		behaviors:
			Countdown: {}
		modelEvents:
			"change": "render"

	class GoalFriendInitiations extends Marionette.CompositeView
		template: require './templates/goal_friend_initiations'
		childView: GoalFriendInitiation
		childViewContainer: "#content"
		emptyView: GoalFriendInitiationsEmpty
		modelEvents:
			"sync" : "render"

	class GoalFriendInitiationsEmpty extends Marionette.ItemView
		template: require './templates/goal_friend_initiation_empty'


	App.reqres.setHandler "goal:initiation:list:my", (region) -> Controller.listMy(region)
	App.reqres.setHandler "goal:initiation:list:my:friend", (region) -> Controller.listMyFriend(region)