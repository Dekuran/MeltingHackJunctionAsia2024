MODEL="gpt-4o"
OPENAI_API_KEY = "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"
INGREDIENT_IMAGE_PROCESSING_SYSTEM_PROMPT = """
        You are a helpful assistant that identifies the ingredients from images of food and drinks packaging labels. Labels may be in English or other languages like Korean.
        If text in the image is not English, first translate to English.
        If there's no text, make a guess based on the type of food shown.
         Return a JSON output of the ingredients in STRICTLY the following format as an array of JSON objects:

         [
            {
                "product": "product name that ingredients are for string"
                "ingredient": "ingredient name string",
                "ingredientType": "ingredient type string",
                "amount": float,
                "unit": "unit string"
            },
         ]
         For vitamins, in "ingredient" always put the word "vitamin" in front of the designation - e.g. "B6" should always be "Vitamin B6" and D should be "Vitamin D"
         Guess product (this should refer to the product that the ingredients are for e.g. a soft drink like red bull or a pack of chips like Lays ready salted chips) - there may be a label that helps you. 
         Guess ingredientType, or if there is a parenthesis each item in the parenthesis should become an object. 
         Examples:
         - Acidity Regulators (a, b, c) then each of a,b,c should return 3 "ingredient" JSON objects where "ingredientType" == "Acidity Regulators" and "ingredient" = "a", "b", or "c"
         - Color (Plain Caramel, Spirule) should return two entries: 
            1) {"ingredient": "Plain Caramel", "ingredientType": "Color", "amount": , "unit":""}
            2) {"ingredient": "Spirule", "ingredientType": "Color", "amount": , "unit":""}
         
         Only return VALID JSON with no explanation or comments.

         """

INGREDIENT_IMAGE_PROCESSING_USER_PROMPT = """"
             List the ingredients of this product strictly in the JSON format you have been given.
             If you cannot read ingredients in the image well then do your best to guess.
             This could affect people's dietary choices and health so DO NOT HALLUCINATE OR PROVIDE INACCURATE DATA.
             Only return VALID JSON with no explanation or comments.
             """


RESPONSES_SAVE_LOCATION = "backend/data/ingredient_image_responses.csv"

FDA_INGREDIENT_LOOKUP_LOCATION = "backend/data/fda_additives_reference.csv"

USER_DATA_LOCATION = "backend/data/userData.csv"


INGREDIENT_TEXT_PROCESSING_SYSTEM_PROMPT = """
        You are a helpful assistant that identifies the ingredients from questions from users
         in multiple languages and returns a JSON output of the ingredients in STRICTLY the following format:

         {
            "ingredient": "ingredient name string",
            "ingredientType": "ingredient type string",
            "amount": float,
            "unit": "unit string"
        }
         Guess ingredientType. Leave amount and unit blank.
         
         Only return VALID JSON with no explanation or comments.
         """



AVG_PREGNANCY_DURATION_DAYS = 268 # source = https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3777570/


DESCRIBE_IMAGE_SYSTEM = "You are a helpful assistant who describes images"

DESCRIBE_IMAGE_USER = "Describe this image"