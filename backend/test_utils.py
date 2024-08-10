import utils

client = utils.get_openai_client()
user = "id_8"
IMG = "backend/image/redbull_ingredients.png"

def generate_response(image, user):
    image = utils.encode_image(image)
    imageIngredientsJson = utils.identify_ingredients_from_label(image, client)
    imageIngredientsDf = utils.process_new_ingredient_image_response(imageIngredientsJson)
    imageIngredientsWithUserDataDf = utils.add_selected_user_data_to_ingredients(imageIngredientsDf, user)
    outputJSON = utils.compare_new_ingredient_image_response_to_risk_lookup(imageIngredientsWithUserDataDf)
    return outputJSON

testOutput= generate_response(IMG, user)


print("finished_running")
print(testOutput)