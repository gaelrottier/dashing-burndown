class Dashing.Burndown extends Dashing.Widget

    # Represents the percentage of the height of the widget which is occupied by the graph
    RATIO = 0.9

    ready: ->
        container           = $(@node).parent()
        @width              = Dashing.widget_base_dimensions[0]
        @widget_height = Dashing.widget_base_dimensions[1]
        @graph_height  = @widget_height * RATIO
        @graph             = new Rickshaw.Graph(
            element: @node
            interpolation: 'step-after'
            width: @width
            height: @graph_height
            series: [
                {
                    color: '#6FCEDB',
                    data: [{ x: 0, y: 0}]
                }
            ]
        )

        if @get('points')
            points = @get('points')
            @graph.series[0].data = @get('points')
            @placeMax(points)

        $('.max-points').css('top', '3%')

        @showInfo()

    onData: (data) ->
        if @graph
            @graph.series[0].data = data.points
            @showInfo()
            @placeMax(data.points)

    showInfo: ->
        @graph.render()
        @updateSeries()
        @updateMaxDataIndex()
        @placeInfo()

    placeMax: (points) ->
        $('.max-points').text(points[0].y)

    updateSeries: ->
        @series = @graph.series[0]

    updateMaxDataIndex: ->
        @maxDataIndex = @series.data[@series.data.length - 1].x

    placeInfo: ->
        points = ''
        divPoints = $('.points')

        for data in @series.data
            if data.y isnt null
                points = data.y
                day = data.x

        divPoints.text(points)
        stepX = @width / @maxDataIndex
        locX  = stepX * day
        stepY = @graph_height / @series.data[0].y
        locY  = stepY * points

        divPoints.css('margin-left', "#{locX}px")
        divPoints.css('bottom', "#{locY}px")

        if points == 0
            divPoints.css('display', 'none')
        else
            divPoints.css('display', 'block')
