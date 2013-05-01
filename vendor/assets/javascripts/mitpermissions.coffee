# Public: Plugin for setting permissions on newly created annotations as well as
# managing user permissions such as viewing/editing/deleting annotions.
#
# element - A DOM Element upon which events are bound. When initialised by
#           the Annotator it is the Annotator element.
# options - An Object literal containing custom options.
#
# Examples
#
#   new Annotator.plugin.Permissions(annotator.element, {
#     user: 'Alice'
#   })
#
# Returns a new instance of the Permissions Object.
class Annotator.Plugin.MITPermissions extends Annotator.Plugin.Permissions

  # A Object literal consisting of event/method pairs to be bound to
  # @element. See Delegator#addEvents() for details.
  events:
    'beforeAnnotationCreated': 'addFieldsToAnnotation'


  # The constructor called when a new instance of the Permissions
  # plugin is created. See class documentation for usage.
  #
  # element - A DOM Element upon which events are bound..
  # options - An Object literal containing custom options.
  #
  # Returns an instance of the Permissions object.
  constructor: (element, options) ->
    super

    if @options.user
      this.setUser(@options.user)
      delete @options.user

  # Public: Initializes the plugin and registers fields with the
  # Annotator.Editor and Annotator.Viewer.
  #
  # Returns nothing.
  pluginInit: ->
    return unless Annotator.supported()

    self = this
    createCallback = (method, type) ->
      (field, annotation) -> self[method].call(self, type, field, annotation)

    @annotator.editor.addField({
      type:   'radio'
      name:   'permission-chooser'
      label:  Annotator._t('Group')
      load:   createCallback('updatePermissionsField', 'read')
      submit: createCallback('updateAnnotationPermissions', 'read')
    })

    @annotator.editor.addField({
      type:   'radio'
      name:   'permission-chooser'
      label:  Annotator._t('Review')
      load:   createCallback('updatePermissionsField', 'update')
      submit: createCallback('updateAnnotationPermissions', 'update')
    })

    @annotator.editor.addField({
      type:   'radio'
      name:   'permission-chooser'
      label:  Annotator._t('Private')
      load:   createCallback('updatePermissionsField', 'update')
      submit: createCallback('updateAnnotationPermissions', 'update')
    })

    # Setup the display of annotations in the Viewer.
    @annotator.viewer.addField({
      load: this.updateViewer
    })

    # Add a filter to the Filter plugin if loaded.
    if @annotator.plugins.Filter
      @annotator.plugins.Filter.addFilter({
        label: Annotator._t('User')
        property: 'user'
        isFiltered: (input, user) =>
          user = @options.userString(user)

          return false unless input and user
          for keyword in (input.split /\s*/)
            return false if user.indexOf(keyword) == -1

          return true
      })

  # Public: Sets the Permissions#user property.
  #
  # user - A String or Object to represent the current user.
  #
  # Examples
  #
  #   permissions.setUser('Alice')
  #
  #   permissions.setUser({id: 35, name: 'Alice'})
  #
  # Returns nothing.
  setUser: (user) ->
    @user = user

  # Event callback: Appends the @user and @options.permissions objects to the
  # provided annotation object. Only appends the user if one has been set.
  #
  # annotation - An annotation object.
  #
  # Examples
  #
  #   annotation = {text: 'My comment'}
  #   permissions.addFieldsToAnnotation(annotation)
  #   console.log(annotation)
  #   # => {text: 'My comment', permissions: {...}}
  #
  # Returns nothing.
  addFieldsToAnnotation: (annotation) =>
    if annotation
      annotation.permissions = @options.permissions
      if @user
        annotation.user = @user

  # Public: Determines whether the provided action can be performed on the
  # annotation. This uses the user-configurable 'userAuthorize' method to
  # determine if an annotation is annotatable. See the default method for
  # documentation on its behaviour.
  #
  # Returns a Boolean, true if the action can be performed on the annotation.
  authorize: (action, annotation, user) ->
    user = @user if user == undefined

    if @options.userAuthorize
      return @options.userAuthorize.call(@options, action, annotation, user)

    else # userAuthorize nulled out: free-for-all!
      return true

  # Field callback: Updates the state of the "anyone can…" checkboxes
  #
  # action     - The action String, either "view" or "update"
  # field      - A DOM Element containing a form input.
  # annotation - An annotation Object.
  #
  # Returns nothing.
  updatePermissionsField: (action, field, annotation) =>
    field = $(field).show()
    input = field.find('input').removeAttr('disabled')

    # Do not show field if current user is not admin.
    field.hide() unless this.authorize('admin', annotation)

    # See if we can authorise without a user.
    if this.authorize(action, annotation || {}, null)
      input.attr('checked', 'checked')
    else
      input.removeAttr('checked')


  # Field callback: updates the annotation.permissions object based on the state
  # of the field checkbox. If it is checked then permissions are set to world
  # writable otherwise they use the original settings.
  #
  # action     - The action String, either "view" or "update"
  # field      - A DOM Element representing the annotation editor.
  # annotation - An annotation Object.
  #
  # Returns nothing.
  updateAnnotationPermissions: (type, field, annotation) =>
    console.log type
    # console.log field
    # console.log annotation
	annotation.permissions = @options.permissions unless annotation.permissions

    dataKey = type + '-permissions'

    if $(field).find('input').is(':checked')
      annotation.permissions[type] = []
    else
      # Clearly, the permissions model allows for more complex entries than this,
      # but our UI presents a checkbox, so we can only interpret "prevent others
      # from viewing" as meaning "allow only me to view". This may want changing
      # in the future.
      annotation.permissions[type] = [@user]

  # Field callback: updates the annotation viewer to inlude the display name
  # for the user obtained through Permissions#options.userString().
  #
  # field      - A DIV Element representing the annotation field.
  # annotation - An annotation Object to display.
  # controls   - A control Object to toggle the display of annotation controls.
  #
  # Returns nothing.
  updateViewer: (field, annotation, controls) =>
    field = $(field)

    username = @options.userString annotation.user
    if annotation.user and username and typeof username == 'string'
      user = Annotator.$.escape(@options.userString(annotation.user))
      field.html(user).addClass('annotator-user')
    else
      field.remove()

    if controls
      controls.hideEdit()   unless this.authorize('update', annotation)
      controls.hideDelete() unless this.authorize('delete', annotation)

  # Sets the Permissions#user property on the basis of a received authToken.
  #
  # token - the authToken received by the Auth plugin
  #
  # Returns nothing.
  _setAuthFromToken: (token) =>
    this.setUser(token.userId)
