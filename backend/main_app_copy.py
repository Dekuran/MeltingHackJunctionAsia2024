from flask import Flask, request, redirect, render_template
import os
import base64
from openai import OpenAI
from IPython.display import Image, display, Audio, Markdown
import base64

import constants
import utils

client = utils.get_openai_client()

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
    if request.method == "POST":
        if request.files:
            image = request.files["image"]
            image_path = os.path.join(app.config["IMAGE_UPLOADS"], image.filename)
            image.save(image_path)

            # encode image
            base64_image = utils.encode_image(image_path)
            # gen response from OpenAI API
            response = generate_response(base64_image)

            return render_template("index.html", res=response)#, uploaded_image=image.filename)
    return render_template("index.html")


@app.route('/uploads/<filename>')
def send_uploaded_file(filename=''):
    from flask import send_from_directory
    return send_from_directory(app.config["IMAGE_UPLOADS"], filename)



if __name__ == "__main__":
    app.run(
        #host='localhost', 
        debug=True
        )


    
# # render index.html page
# @app.route("/")
# def home():
#     return render_template("index.html")
