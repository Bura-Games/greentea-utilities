--!optimize 2
--!strict

local EnglishUtilities = {}

local VOWELS = {
	[65] = true;
	[69] = true;
	[73] = true;
	[79] = true;
	[85] = true;
	[97] = true;
	[101] = true;
	[105] = true;
	[111] = true;
	[117] = true;
}

function EnglishUtilities.GetIndefiniteArticle(value: string)
	return if VOWELS[string.byte(value)] then "an" else "a"
end

return table.freeze(EnglishUtilities)
