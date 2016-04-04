module CodeGen::MVC6::Wrappers::ChartGenerator

    CHART_SERIES = YAML.load(File.read("build/codegen/lib/mvc-6/config/chart-series.yml"))
    CHART_SERIES_DEFAULTS_BUILDER = ERB.new(File.read("build/codegen/lib/mvc-6/templates/chart-series-defaults-builder.erb"), 0, '%<>')
    CHART_SERIES_DEFAULTS_SETTINGS = ERB.new(File.read("build/codegen/lib/mvc-6/templates/chart-series-defaults-settings.erb"), 0, '%<>')
    CHART_SERIES_FACTORY = ERB.new(File.read("build/codegen/lib/mvc-6/templates/chart-series-factory.erb"), 0, '%<>')
    CHART_SERIES_FACTORY_OVERLOADS = ERB.new(File.read("build/codegen/lib/mvc-6/templates/chart-series-factory-overloads.erb"), 0, '%<>')
    PRIMITIVE_CSHARP_TYPES = [
        'string'
    ]
    def generate_chart
        write_chart_series_defaults_builder
        write_chart_series_defaults_settings
        write_chart_series_factory
    end

    def write_chart_series_defaults_settings
        filename = "#{@path}/Chart/Settings/ChartSeriesDefaultsSettings.Generated.cs"
        write_file(filename, CHART_SERIES_DEFAULTS_SETTINGS.result(binding))
    end

    def write_chart_series_defaults_builder
        filename = "#{@path}/Chart/Fluent/ChartSeriesDefaultsSettingsBuilder.Generated.cs"
        write_file(filename, CHART_SERIES_DEFAULTS_BUILDER.result(binding))
    end

    def write_chart_series_factory
        filename = "#{@path}/Chart/Fluent/ChartSeriesFactory.Generated.cs"

        CHART_SERIES.each do |series|
            required_fields = series[:fields].select { |field| !field[:optional] }
            overloads = series_overloads(series, required_fields)
            has_optional_fields = series[:fields].length != required_fields.length

            if has_optional_fields
                overloads += series_overloads(series, series[:fields])
            end

            series[:required_fields] = required_fields
            series[:expression_overloads] = overloads
        end

        write_file(filename, CHART_SERIES_FACTORY.result(binding))
    end

    def primitive_type?(type)
        PRIMITIVE_CSHARP_TYPES.include?(type)
    end

    def default_series_name(series)
        fields_in_series_name = series[:required_fields].select { |field| !field[:skip_in_name] }
        name = fields_in_series_name.map { |field| "#{field[:member]}.AsTitle()" }.join(' + ", " + ')
        name
    end

    def series_overloads(series, fields)
        CHART_SERIES_FACTORY_OVERLOADS.result(binding)
    end



    def unique_generic_types(fields)
        field_with_generic = fields.select { |field| !primitive_type?(field[:generic]) }
        generic_types = field_with_generic.map { |field| field[:generic] }
        generic_types.uniq
    end
end