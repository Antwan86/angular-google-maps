angular.module("google-maps.directives.api.models.parent".ns())
.factory "ImageMapParentModel".ns(), ["BaseObject".ns(), "Logger".ns(), '$timeout',(BaseObject, Logger,$timeout) ->
    class ImageMapParentModel extends BaseObject
        constructor: (@scope, @element, @attrs, @gMap, @$log = Logger) ->
            unless @attrs.options?
                @$log.info("options attribute for the image-map directive is mandatory. Image map creation aborted!!")
                return
            @createGoogleImageMapType()
            @doShow = true

            @doShow = @scope.show if angular.isDefined(@attrs.show)
            @gMap.overlayMapTypes.push @imageMapType if @doShow and @gMap?
            @scope.$watch("show", (newValue, oldValue) =>
                if newValue isnt oldValue
                    @doShow = newValue
                    if newValue
                        @gMap.overlayMapTypes.push @imageMapType
                    else
                        @gMap.overlayMapTypes.removeAt 0
            , true)
            @scope.$watch("options", (newValue, oldValue) =>
                unless _.isEqual newValue, oldValue
                    @refreshImageMapType()
            , true)
            @scope.$watch("refresh", (newValue, oldValue) =>
                unless _.isEqual newValue, oldValue
                    @refreshImageMapType()
            , true) if angular.isDefined(@attrs.refresh)
            @scope.$on "$destroy", =>
                @gMap.overlayMapTypes.removeAt 0

        createGoogleImageMapType: ()=>
            @imageMapType = new google.maps.ImageMapType @scope.options

            if @attrs.id and @scope.id
                @gMap.mapTypes.set(@scope.id, @imageMapType)

        refreshImageMapType: ()=>
            @gMap.overlayMapTypes.removeAt 0
            @imageMapType = null
            @createGoogleImageMapType()
            @gMap.overlayMapTypes.push @imageMapType if @doShow and @gMap?
    ImageMapParentModel
]
