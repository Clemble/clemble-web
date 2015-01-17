@App.module "FeedApp.List", (List, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	class Post extends Marionette.ItemView
		template: require './templates/player_post'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalStartedPost extends Marionette.ItemView
		template: require './templates/goal_started'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalCreatedPost extends Marionette.ItemView
		template: require './templates/goal_created'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalBetChangedPost extends Marionette.ItemView
		template: require './templates/goal_bid'
		className: 'row'
		events:
			'click #bet' : "bet"
			'click #support': 'support'
			'click #observe': 'observe'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalUpdatedPost extends Marionette.ItemView
		template: require './templates/goal_update'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalReachedPost extends Marionette.ItemView
		template: require './templates/goal_reached'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class GoalMissedPost extends Marionette.ItemView
		template: require './templates/goal_missed'
		className: 'row'
		behaviors:
			SocialShare: {}
			BetBehavior: {}
			BootstrapTooltip: {}

	class Notifications extends Marionette.CompositeView
		template: require './templates/player_posts'
		childView : Post
		childViewContainer : "#caption"
		modelEvents:
			"sync" : "render"
		getChildView: (item) ->
			if (item.get('type') == "post:goal:created")
				GoalCreatedPost
			else if (item.get('type') == "post:goal:started")
				GoalStartedPost
			else if (item.get('type') == "post:goal:bet:changed")
				GoalBetChangedPost
			else if (item.get('type') == "post:goal:updated")
				GoalUpdatedPost
			else if (item.get('type') == "post:goal:reached")
				GoalReachedPost
			else if (item.get('type') == "post:goal:missed")
				GoalMissedPost
			else
				Post

	Controller =
		listMy: (region) ->
			notification = App.request "feed:entities:my"
			notificationView = new Notifications
				collection: notification
			region.show notificationView

	App.reqres.setHandler "feed:list:my", (region) -> Controller.listMy(region)