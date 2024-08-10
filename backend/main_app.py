from flask import Flask, request, redirect, render_template
import os
import base64
from openai import OpenAI
from IPython.display import Image, display, Audio, Markdown
import base64

app = Flask(__name__)

app.config["IMAGE_UPLOADS"] = "./image"
def generate_response(image):
    # call OpenAI client and specify the model
    MODEL="gpt-4o"
    client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY", "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"))
    answer = client.chat.completions.create(
        model=MODEL,
        messages=
        [
            {"role": "system", "content": """
            You are a helpful assistant that identifies the ingredients from images of food and drinks packaging labels 
            in multiple languages and returns a JSON output of the ingredients in the following format:

            {
                "ingredient": "ingredient name string",
                "ingedient type": "ingredient type string",
                "amount": float,
                "unit": "unit string"
            }
            Guess ingredient type, or if there is a parenthesis each item in the parenthesis should become an object. 
            For example: got the ingredient Acidity Regulators (a, b, c) then each of a,b,c should be one "ingredient" 
            JSON object where "ingredient type" == "Acidity Regulators".
            Only return VALID JSON with no explanation or comments.

            
            """},
            {"role": "user", "content": [
                {"type": "text", "text": """"
                List the ingredients of this product strictly in the JSON format you have been given.
                If you cannot read ingredients in the image DO NOT GUESS, simply return an empty JSON struct. 
                This could affect people's dietary choices and health so DO NOT HALLUCINATE OR PROVIDE INACCURATE DATA.
                Only return VALID JSON with no explanation or comments.
                """},
                {"type": "image_url", "image_url": {
                    "url": f"data:image/png;base64,{image}"}
                }
            ]}
        ],
        temperature=0.0,
    )
    # calculate the deadly compounds
    return (answer.choices[0].message.content)

# Open the image file and encode it as a base64 string
IMAGE_PATH = os.path.join(app.config["IMAGE_UPLOADS"], "redbull_ingredients.png")
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

# Route to upload image
@app.route('/', methods=['GET', 'POST'])
def upload_image():
    if request.method == "POST":
        if request.files:
            image = request.files["image"]
            image_path = os.path.join(app.config["IMAGE_UPLOADS"], image.filename)
            image.save(image_path)

            # encode image
            base64_image = encode_image(image_path)
            # gen response from OpenAI API
            response = generate_response(base64_image)

            return render_template("index.html", res=response, uploaded_image=image.filename)
    return render_template("index.html")


@app.route('/uploads/<filename>')
def send_uploaded_file(filename=''):
    from flask import send_from_directory
    return send_from_directory(app.config["IMAGE_UPLOADS"], filename)



if __name__ == "__main__":
    app.run(host='localhost', debug=True)


    
# # render index.html page
# @app.route("/")
# def home():
#     return render_template("index.html")
