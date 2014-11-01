@App.module "RegistrationBaseApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	Controller =
		registerManual: (region) ->
			layout = new RegistrationLayout()
			layout.on 'show', () ->
				signIn = App.request 'registration:login:show:signIn', layout.signIn
				login = App.request 'registration:login:show:new', layout.login
				profile = App.request 'player:profile:new', layout.profile

				App.request "registration:social:facebook", layout.social

				registration = App.request 'registration:base:entities:new', login, profile
				manual = new RegistrationControl
					model: registration
				layout.control.show manual
			region.show layout

	class RegistrationControl extends Marionette.ItemView
		template: require './templates/control'
		modelEvents:
			'change'  : 'render'
		events:
			'click #signUp' : 'singUp'
		singUp: () ->
			view = @
			@model.save(@model.toJSON(), {
				success: () ->
					view.remove()
					Backbone.history.navigate("/", { trigger: true })
				error: () ->
					console.log("NO Error Processing for signUp failure")
			})


	class RegistrationLayout extends Marionette.LayoutView
		template: require "./templates/layout"
		regions:
			login    : '#login'
			profile  : '#profile'
			control  : '#control'
			signIn   : '#signIn'
			social   : '#social'

	App.reqres.setHandler 'registration:base:show', (region) -> Controller.registerManual(region)
