clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance

class Annotator.Plugin.MarginViewerObjectStore
  constructor: (data=[] , paramFuncObject , @idfield="id" , @marginobjfield="_marginObject" , @indexfield="_marginindex") ->
    @funcObject = clone(paramFuncObject)
    @funcObject.sortDataComparison = (x,y) => paramFuncObject.sortComparison(x[0],y[0])
    @funcObject.mapFunc = (x) => [paramFuncObject.sortDataMap(x),x]
    @data=data.map(@funcObject.mapFunc)
    @data.sort(@funcObject.sortDataComparison)
    @deletions=0
    @insertions=0
    if(@data.length>0)
      for index in [0..@data.length-1]
        obj=@data[index][1]
        obj[@indexfield]=index
  
  getMarginObjects: -> @data.map((x) -> x[1])

  updateObjectLocation: (obj) ->
    objIndex = @getObjectLocation(obj)
    @data[objIndex]=[@funcObject.sortDataMap(obj),obj]
    obj[@indexfield]=objIndex

  objectEquals: (obj1,obj2) ->
    if ("id" of obj1) and ("id" of obj2)
      return obj1.id is obj2.id
    if ("id" of obj1) or ("id" of obj2)
      return false
    if (@indexfield of obj1) and (@indexfield of obj2)
      return obj1[@indexfield] is obj2[@indexfield]
    return false
    
  getObjectLocation: (obj) -> 
    supposedLocation = obj[@indexfield]
    # object is at its internally stored location
    if @objectEquals(@data[supposedLocation][1],obj)
      return supposedLocation
    minimumIndex=Math.max(0,@deletions)
    maximumIndex=Math.min(@data.length-1,@insertions) 
    for index in [minimumIndex..maximumIndex]
      currentObject = @data[index][1]
      if @objectEquals(currentObject,obj)
        currentObject[@indexField]=index 
        return index
    return -1

  getNewLocationsForObject : (top,bottom,obj) ->
    objectIndex = @getObjectLocation(obj.annotation)
    currentIndex = objectIndex-1
    currentNewTop = top
    currentNewBottom = bottom
    locationChanges=[]
    # get preceding objects that need to be moved
    while currentIndex>=0
      currentObject=@data[currentIndex][1][@marginobjfield]
      currentObjectSize=$(currentObject).outerHeight(true)
      currentObjectTop=$(currentObject).offset().top
      currentObjectBottom=currentObjectTop+currentObjectSize
      currentObjectGoalLocation=@funcObject.sortDataMap(currentObject.annotation)
      currentObjectGoalBottom=currentObjectGoalLocation.top+currentObjectSize
      if currentObjectBottom>currentNewTop
        # move up
        objectNewTop=currentNewTop-currentObjectSize
        locationChanges.push([objectNewTop,currentObject])
        currentNewTop=objectNewTop
      else
        # object doesnt needs to be moved up, maybe it should be moved down
        # if object isnt at its 'natural' location, move down as far as possible
        if currentObjectGoalLocation.top>currentObjectTop
          if currentObjectGoalBottom<currentNewTop
            # if object can reach goal, send to goal
            objectNewTop=currentObjectGoalLocation.top
            locationChanges.push([objectNewTop,currentObject])
            currentNewTop=currentObjectGoalLocation.top
          else
            # bring object as close as possible
            objectNewTop=currentNewTop-currentObjectSize
            locationChanges.push([objectNewTop,currentObject])
            currentNewTop=objectNewTop
        else
          break
      currentIndex-=1
    # get succeeding objects that need to be moved
    currentIndex = objectIndex+1
    while currentIndex<@data.length
      currentObject=@data[currentIndex][1][@marginobjfield]
      currentObjectSize=$(currentObject).outerHeight(true)
      currentObjectTop=$(currentObject).offset().top
      currentObjectBottom=currentObjectTop+currentObjectSize
      currentObjectGoalLocation=@funcObject.sortDataMap(currentObject.annotation)
      currentObjectGoalBottom=currentObjectGoalLocation.top+currentObjectSize
      if currentObjectTop<currentNewBottom
        # move down
        objectNewTop=currentNewBottom
        locationChanges.push([objectNewTop,currentObject])
        currentNewBottom=objectNewTop+currentObjectSize
      else
        # object doesnt need to be moved down, maybe it should be moved up
        # if object isnt at its 'natural' location, move up as far as possible
        if currentObjectGoalLocation.top<currentObjectTop
          if currentObjectGoalLocation.top>currentNewBottom
            # if object can reach goal, send to goal
            objectNewTop=currentObjectGoalLocation.top
            locationChanges.push([objectNewTop,currentObject])
            currentNewBottom=objectNewTop+currentObjectSize
          else
            # bring object as close as possible
            objectNewTop=currentNewBottom
            locationChanges.push([objectNewTop,currentObject])
            currentNewBottom=objectNewTop+currentObjectSize
        else
          break
      currentIndex+=1
    return locationChanges

  # binary search
  findIndexForNewObject : (location) ->
    startIndex=0
    endIndex=@data.length
    while startIndex<endIndex
      currentIndex=Math.floor((startIndex+endIndex)/2)
      if @funcObject.sortComparison(location,@data[currentIndex][0])>0
        startIndex=currentIndex+1
      else
        endIndex=currentIndex
    return startIndex

  addNewObject : (obj,topval,leftval) ->
    location={top:topval,left:leftval}
    newObjectLocation=@findIndexForNewObject(location)
    if newObjectLocation>0
      @data=@data[0..newObjectLocation].concat([@funcObject.mapFunc(obj)],@data[newObjectLocation+1..@data.length-1])
    else
      @data=[@funcObject.mapFunc(obj)].concat(@data[newObjectLocation..@data.length-1])
    obj[@indexfield]=newObjectLocation
    @insertions+=1
    
  deleteObject : (object) ->
    objectLocation=@getObjectLocation(object)
    if objectLocation>0
      @data=@data[0..objectLocation-1].concat(@data[objectLocation..@data.length-1])
    else
      @data=@data[1..@data.length-1]
    @deletions+=1

class Annotator.Plugin.MarginViewer extends Annotator.Plugin
  constructor : (element,options) ->
    super
    # TODO: get id of div for margin objects from options

  events:
    'annotationsLoaded':    'onAnnotationsLoaded'      
    'annotationCreated':    'onAnnotationCreated'      
    'annotationDeleted':    'onAnnotationDeleted'      
    'annotationUpdated':    'onAnnotationUpdated'      
    '.annotator-hl click':  'onAnnotationSelected'

  pluginInit: ->
    return unless Annotator.supported()
    @annotator.viewer =
      on: ->
      hide: (annotations) => @hideHighlightedMargin(annotations)
      load: (annotations) => @highlightMargin(annotations)
      isShown: ->
      element: 
        position: ->
        css: ->
    @highlightedObjects = []
    @currentSelectedAnnotation = null

    RTL_MULT = -1 #should be -1 if RTL else 1
    sign = (x) ->
      if(x is 0)
        return 0
      else
        return x/Math.abs(x)
    @funcObject =
      sortDataMap: (annotation) ->
        dbg = {top:$(annotation.highlights[0]).offset().top,left:$(annotation.highlights[0]).offset().left}
        return dbg 
      sortComparison : (left,right) -> 
        return sign(sign(left.top - right.top)*2 + sign(left.left - right.left)*RTL_MULT) 
      idFunction : (annotation) -> annotation.id
      sizeFunction : (element) -> element.outerHeight(true)
    @marginData = new Annotator.Plugin.MarginViewerObjectStore [],@funcObject
    
  onAnnotationsLoaded: (annotations) ->
    @marginData = new Annotator.Plugin.MarginViewerObjectStore annotations,@funcObject
    if annotations.length>0
      currentLocation = 0
      for annotation in @marginData.getMarginObjects()
        annotationStart = annotation.highlights[0]
        newLocation = $(annotationStart).offset().top;
        if currentLocation>newLocation
          newLocation=currentLocation
        marginObject=@createMarginObject(annotation,newLocation)
        @marginData.updateObjectLocation(annotation)
        currentLocation = $(marginObject).offset().top+$(marginObject).outerHeight(true)

  onAnnotationCreated: (annotation) ->
    marginObject=@createMarginObject(annotation,hide=true)
    newObjectTop=$(annotation.highlights[0]).offset().top
    newObjectBottom=newObjectTop+$(marginObject).outerHeight(true)
    @marginData.addNewObject(annotation,newObjectTop,$(annotation.highlights[0]).offset().left)
    newLocations=@marginData.getNewLocationsForObject(newObjectTop,newObjectBottom,marginObject)
    @moveObjectsToNewLocation(newLocations)
    $(marginObject).fadeIn('fast').offset({top:newObjectTop})

  onAnnotationSelected: (event) ->
    event.stopPropagation()
    annotations = $(event.target)
      .parents('.annotator-hl')
      .andSelf()
      .map -> return $(this).data("annotation")
    #cycle annotations
    selectIndex=0
    if annotations.length>1
      # find currently annotated object
      for i in [0..annotations.length-1]
        if $(annotations[i]._marginObject).hasClass("annotator-marginviewer-selected")
          selectIndex=(i+1)%annotations.length
          break
    @onMarginSelected(annotations[selectIndex]._marginObject)
 
  onAnnotationDeleted: (annotation) ->
    marginObject=annotation._marginObject
    @marginData.deleteObject(annotation)
    $(marginObject).remove()
    this.publish('delete',[annotation])
    
  deleteHandler : (event) ->
    @onAnnotationDeleted(event.target.annotation)

  zeroPad : (num,count) ->
    numZeroPad = String(num)
    while numZeroPad.length<count
      numZeroPad = "0" + numZeroPad
    return numZeroPad

  formattedDateTime : (dateobj) ->
    meridiemString = if dateobj.getHours()<12 then "AM" else "PM"
    timeString = dateobj.getHours() + ":" + @zeroPad(dateobj.getMinutes(),2) + meridiemString
    dateString = @zeroPad(dateobj.getDate(),2) + "." + @zeroPad(dateobj.getMonth(),2) + "." + dateobj.getFullYear()
    return timeString + " " + dateString

  renderMarginObject : (annotation) ->
    datetime = if annotation.created then @formattedDateTime(new Date annotation.created) else ''
    delel = if annotation.permissions.delete.indexOf(@annotator.plugins.AnnotateItPermissions.user)>=0 then '<span class="annotator-marginviewer-delete" style="float: left; direction: ltr;">X</span>' else ''
    return '<div class="annotator-marginviewer-element"><div class="annotator-marginviewer-header"><span class="annotator-marginviewer-user">'+annotation.user+'</span>'+delel+'<span class="annotator-marginviewer-date" style="float: left; direction: ltr;">'+datetime+'</span></div><div class="annotator-marginviewer-text">'+annotation.text+'</div></div>'

  createMarginObject : (annotation, location=null, hide=false) ->
    marginObjects=$(@renderMarginObject(annotation)).appendTo('.secondary').click((event) => @onMarginSelected(event.target)).mouseenter((event) => @onMarginMouseIn(event.target)).mouseleave((event) => @onMarginMouseOut(event.target))
    marginObjects.children(".annotator-marginviewer-header").children(".annotator-marginviewer-delete").click((event) => @onMarginDeleted(event.target))
    if location!=null
      marginObjects.offset({top: location})
    if hide
      marginObjects.hide()
    marginObject=marginObjects[0]
    annotation._marginObject=marginObject
    marginObject.annotation=annotation
    return marginObject

  onAnnotationUpdated: (annotation) ->
    # updates not supported right now

  onMarginMouseIn: (obj) ->
    $($(obj).closest(".annotator-marginviewer-element")[0].annotation.highlights).addClass("annotator-hl-uber-temp").removeClass("annotator-hl")

  onMarginMouseOut: (obj) ->
    $($(obj).closest(".annotator-marginviewer-element")[0].annotation.highlights).addClass("annotator-hl").removeClass("annotator-hl-uber-temp")

  onMarginSelected: (obj) ->
    marginObject = $(obj).closest(".annotator-marginviewer-element")[0]
    annotation = marginObject.annotation
    horizontalSlide=[]
    newTop = $(annotation.highlights[0]).offset().top
    newBottom = $(marginObject).outerHeight(true)+newTop
    newLocationsByObject = @marginData.getNewLocationsForObject(newTop,newBottom,marginObject)
    if @currentSelectedAnnotation != null
      if annotation.id is @currentSelectedAnnotation.id
        return
      else
        currentMarginObject=@currentSelectedAnnotation._marginObject
        $(@currentSelectedAnnotation.highlights).removeClass("annotator-hl-uber").removeClass("annotator-hl-uber-temp").addClass("annotator-hl")
        # find object's new top if it needs to change, also remove it from the list
        currentObjectNewTop = $(currentMarginObject).offset().top
        newLocationsByObject=$.grep(newLocationsByObject,(value) ->
          if value[1].annotation.id is currentMarginObject.annotation.id
            currentObjectNewTop=value[0]
            return false
          else
            return true
        )
        horizontalSlide.push([currentObjectNewTop,"+=20px",currentMarginObject])
        $(currentMarginObject).removeClass("annotator-marginviewer-selected")
    $(marginObject).addClass("annotator-marginviewer-selected")
    horizontalSlide.push([newTop,"-=20px",marginObject])
    @moveObjectsToNewLocation(newLocationsByObject,horizontalSlide)
    $(annotation.highlights).addClass("annotator-hl-uber").removeClass("annotator-hl")
    @currentSelectedAnnotation = annotation

  onMarginDeleted: (obj) ->
    marginObject = $(obj).closest(".annotator-marginviewer-element")[0]
    annotation = marginObject.annotation
    console.log('deleting annotation')
    this.publish('delete',[annotation])

  moveObjectsToNewLocation: (newLocations,horizontalSlideObjects=[]) ->
    for newLocationStructure in newLocations
      newTop = newLocationStructure[0]
      currentObject = newLocationStructure[1]
      $(currentObject).animate({top:"+="+(newTop-$(currentObject).offset().top)},'fast','swing')
      @marginData.updateObjectLocation(currentObject.annotation)
    for horizontalSlide in horizontalSlideObjects
      newTop = horizontalSlide[0]
      newMarginRight = horizontalSlide[1]
      currentObject = horizontalSlide[2]
      $(currentObject).animate({top:"+="+(newTop-$(currentObject).offset().top),'margin-right':newMarginRight},'fast','swing')
      @marginData.updateObjectLocation(currentObject.annotation)

  highlightMargin: (annotations) ->
    if @highlightedObjects.length>0
      oldObjects=[]
      for existingHighlight in @highlightedObjects
        found=false
        for newHighlight in annotations
          if newHighlight.id == existingHighlight.id
            found=true
        if not found
          oldObjects.push(existingHighlight)
      @hideHighlightedMargin oldObjects 
    @highlightedObjects=annotations
    marginObjects=jQuery.map(annotations,(val,i)->val._marginObject)
    $(marginObjects).addClass("annotator-marginviewer-highlighted")

  hideHighlightedMargin: (annotations) ->
    @highlightedObjects=[]
    marginObjects=jQuery.map(annotations,(val,i)->val._marginObject)
    $(marginObjects).removeClass("annotator-marginviewer-highlighted")
