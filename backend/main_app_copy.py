from flask import Flask, request, redirect, render_template, render_template_string
import os
import base64
from openai import OpenAI
from IPython.display import Image, display, Audio, Markdown
import base64
import re

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
        <h1>{{ outputJSON }}</h1>
  </body>
</html>
'''

client = utils.get_openai_client()

img_encoded = utils.encode_image("redbull_ingredients.png")

app_state = {
    'data': "Waiting"
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


# Open the image file and encode it as a base64 string
IMAGE_PATH = os.path.join(app.config["IMAGE_UPLOADS"], "redbull_ingredients.png") # test image

# Route to upload image
@app.route('/', methods=['GET', 'POST'])
def upload_image():
    '''
    if request.method == "POST":
        if request.files:
            image = request.files["image"]
            image_path = os.path.join(app.config["IMAGE_UPLOADS"], image.filename)
            image.save(image_path)

            # encode image
            base64_image = utils.encode_image(image_path)
            # gen response from OpenAI API
            response = generate_response(base64_image)

            return render_template("index.html", res=response)#, uploaded_image=image.filename
    '''
    
    if request.method == "POST":
        app_state['data'] = request.form['data']
        app_state['data'] = re.sub(' ', '+', app_state['data'])
        with open("image_encoded.txt", "w") as text_file:
            text_file.write(app_state['data'])
        ##generate_response(app_state['data'])
    
    if app_state['data'] == "Waiting":
        response = "Waiting"

    else:
        response = generate_response(app_state['data'])
    #response = app_state['data']

    return render_template_string(html_template, content = response)


'''
@app.route('/uploads/<filename>')
def send_uploaded_file(filename=''):
    from flask import send_from_directory
    return send_from_directory(app.config["IMAGE_UPLOADS"], filename)

'''

if __name__ == "__main__":
    app.run(
        #host='localhost', 
        debug=True
    )


    
# # render index.html page
# @app.route("/")
# def home():
#     return render_template("index.html")
