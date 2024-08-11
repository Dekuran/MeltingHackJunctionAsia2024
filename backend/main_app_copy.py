from flask import Flask, request, redirect, render_template, render_template_string
import os
import base64
from openai import OpenAI
from IPython.display import Image, display, Audio, Markdown
import base64
import re
import json

import constants
import utils

# HTML template to display the message
html_template = '''
<!doctype html>
<html lang="en">
  <head>
    <title>Display Text</title>
  </head>
  <body>
        <h1>{{ response }}</h1>
  </body>
</html>
'''

client = utils.get_openai_client()

img_encoded = utils.encode_image("redbull_ingredients.png")

app_state = {
    'data': {"status": "Waiting"}
}

TEST_USER = "id_19"

app = Flask(__name__)

app.config["IMAGE_UPLOADS"] = "backend/image"
def generate_response(image):
    user = TEST_USER
    imageIngredientsJson = utils.identify_ingredients_from_label(image, client)
    imageIngredientsDf = utils.process_new_ingredient_image_response(imageIngredientsJson)
    imageIngredientsWithUserDataDf = utils.add_selected_user_data_to_ingredients(imageIngredientsDf, user)
    outputJSON = utils.compare_new_ingredient_image_response_to_risk_lookup(imageIngredientsWithUserDataDf)
    return outputJSON

def generate_text_response(text):
    user = TEST_USER
    imageIngredientsJson = utils.identify_ingredients_from_text(text, client)
    imageIngredientsDf = utils.process_new_ingredient_image_response(imageIngredientsJson)
    imageIngredientsWithUserDataDf = utils.add_selected_user_data_to_ingredients(imageIngredientsDf, user)
    outputJSON = utils.compare_new_ingredient_image_response_to_risk_lookup(imageIngredientsWithUserDataDf)
    return outputJSON


# Open the image file and encode it as a base64 string
IMAGE_PATH = os.path.join(app.config["IMAGE_UPLOADS"], "redbull_ingredients.png") # test image

# Route to upload image
@app.route('/', methods=['GET', 'POST'])
def upload_image():
    
    if request.method == "POST":
        app_state['data'] = request.form['data']
        app_state['data'] = re.sub(' ', '+', app_state['data'])
        with open("image_encoded.txt", "w") as text_file:
            text_file.write(app_state['data'])
        ##generate_response(app_state['data'])
    
    if app_state['data'] == {"status": "Waiting"}:
        response = app_state['data']

    else:
        if "THIS_IS_AN_IMAGE_FILE" in app_state['data']:
            app_state['data'] = re.sub('THIS_IS_AN_IMAGE_FILE', '', app_state['data'])
            query_output = generate_response(app_state['data'])
            # Join the list into a single string (in case it's stored as a list of one string)
            data_string = query_output[0]
            # Split the string by the newline character to get individual JSON strings
            json_strings = data_string.strip().split('\n')
            # Parse each JSON string into a dictionary
            response = [json.loads(json_str) for json_str in json_strings]
        elif "THIS_IS_A_TEXT_FILE" in app_state['data']:
            app_state['data'] = re.sub('THIS_IS_A_TEXT_FILE', '', app_state['data'])
            query_output = generate_text_response(app_state['data'])
            # Join the list into a single string (in case it's stored as a list of one string)
            data_string = query_output[0]
            # Split the string by the newline character to get individual JSON strings
            json_strings = data_string.strip().split('\n')
            # Parse each JSON string into a dictionary
            response = [json.loads(json_str) for json_str in json_strings]
        else:
            response = app_state['data']

    #print(response)

    return response #render_template_string(html_template, content = response)


if __name__ == "__main__":
    app.run(
        #host='localhost', 
        debug=True
    )


    
# # render index.html page
# @app.route("/")
# def home():
#     return render_template("index.html")
