Demo = Ember.Application.create()
Demo.Store = DS.Store.extend()
Demo.ApplicationAdapter = DS.RESTAdapter

Demo.Router.map ->
  @resource 'posts', path: '/posts', ->
    @route 'nuevo'
    @resource 'post', path: '/:post_id'

Demo.IndexRoute = Ember.Route.extend
  beforeModel: ->
    @transitionTo 'posts'

Demo.PostsRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'post'

Demo.PostsNuevoRoute = Ember.Route.extend
  model: ->
    @store.createRecord('post')

  setupController: (controller, model) ->
    @controllerFor('post').set('model', model)

  renderTemplate: ->
    controller = @controllerFor('post')
    controller.set('editando', true)
    @render 'post', into: 'posts', controller: controller

Demo.Post = DS.Model.extend
  titulo: DS.attr 'string'
  texto:  DS.attr 'string'
  autor:  DS.attr 'string'

Demo.PostsController = Ember.ArrayController.extend
  actions:
    crear: ->
      @transitionToRoute 'posts.nuevo'

Demo.PostController = Ember.ObjectController.extend
  editando: false
  modificado: Ember.computed.not 'content.isDirty'

  actions:
    guardar: ->
      @get('model').save().then ->
        alert 'Ha ocurrido un error'
      , =>
        alert 'Post guardado con éxito'
        @set('editando', false)
        @transitionToRoute 'posts'

    cancelar: ->
      @set('editando', false)
      @transitionToRoute 'posts' if @get('model').get('isNew')
      @get('model').rollback()

    editar: ->
      @set('editando', true)

    eliminar: ->
      return unless confirm('Confirmar eliminación')
      @get('model').destroyRecord().then =>
        alert 'Ha ocurrido un error al eliminar el post'
      , =>
        @set('editando', false)
        @transitionToRoute 'posts'
