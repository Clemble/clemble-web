@App.module "PlayerAccountApp", (PlayerAccountApp, App, Backbone, Marionette, $, _) ->

	class PlayerAccount extends Backbone.Model
		defaults:
			player: null,
			cash: null
		idAttribute:
			'player'

	API =
		get: (player) ->
			account = new PlayerAccount(player: player)
			account.urlRoot = "http://#{App.host}/payment/account/"
			account.fetch()
			account

	App.reqres.setHandler "player:account:entities:get", (player) -> API.get(player)