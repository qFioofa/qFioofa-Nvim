return {
	template = {
		annotation = {
			{ nil, "/**" },
			{ nil, " * ${1:Description}" },
			{ nil, " *" },
			{
				"attribute_class",
				" * @param ${1:name} ${2:Description}",
			},
			{
				"attribute_method",
				" * @param ${1:name} ${2:Description}",
			},
			{ "attribute_return", " * @return ${1:Description}" },
			{
				"attribute_throws",
				" * @throws ${1:Exception} ${2:Description}",
			},
			{ nil, " */" },
		},
	},
}
