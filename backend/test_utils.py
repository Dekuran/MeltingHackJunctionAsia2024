import utils

client = utils.get_openai_client()
user = "id_8"
IMG = "backend/image/redbull_ingredients.png"
#IMG = "backend/highres_img.jpg"

def generate_response(image, user):
    image = utils.encode_image(image)
    #print(image)
    #print(len(image.encode('utf-8')))

    
    with open("image_encoded.txt", "w") as text_file:
        text_file.write(image)
    with open('image_encoded.txt', 'r') as file:
        imgtry = file.read()
    
    imageIngredientsJson = utils.identify_ingredients_from_label(imgtry, client)
    imageIngredientsDf = utils.process_new_ingredient_image_response(imageIngredientsJson)
    imageIngredientsWithUserDataDf = utils.add_selected_user_data_to_ingredients(imageIngredientsDf, user)
    outputJSON = utils.compare_new_ingredient_image_response_to_risk_lookup(imageIngredientsWithUserDataDf)

    return outputJSON

testOutput= generate_response(IMG, user)


print("finished_running")
print(testOutput)