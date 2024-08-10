
from constants import MODEL, OPENAI_API_KEY, INGREDIENT_IMAGE_PROCESSING_SYSTEM_PROMPT, INGREDIENT_IMAGE_PROCESSING_USER_PROMPT, RESPONSES_SAVE_LOCATION, FDA_INGREDIENT_LOOKUP_LOCATION, INGREDIENT_TEXT_PROCESSING_SYSTEM_PROMPT, USER_DATA_LOCATION
from openai import OpenAI
import os
import pandas as pd
import datetime
from IPython.display import Image, display, Audio, Markdown
import base64

def get_openai_client():
    return OpenAI(api_key=os.environ.get("OPENAI_API_KEY", OPENAI_API_KEY))

def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

    
def identify_ingredients_from_label(base64_image, client):
    response = client.chat.completions.create(
    model=MODEL,
    messages=[
        {"role": "system", "content": INGREDIENT_IMAGE_PROCESSING_SYSTEM_PROMPT},
        {"role": "user", "content": [
            {"type": "text", "text": INGREDIENT_IMAGE_PROCESSING_USER_PROMPT},
            {"type": "image_url", "image_url": {
                "url": f"data:image/png;base64,{base64_image}"}
            }
        ]}
    ],
    temperature=0.0,
    )
    return response.choices[0].message.content


def process_new_ingredient_image_response(responseJSON):
    this_response_df = pd.DataFrame(pd.read_json(responseJSON))
    past_responses_df = pd.read_csv(RESPONSES_SAVE_LOCATION)
    MAX_RESPONSE_NO = max(max(past_responses_df["responseNo"]), 1)
    this_response_df["responseNo"] = MAX_RESPONSE_NO + 1
    this_response_df["responseId"] = this_response_df["responseNo"].astype('str')
    this_response_df["responseTimeStamp"] = pd.Timestamp.now()
    responses_df = pd.concat([past_responses_df, this_response_df])
    responses_df.to_csv(RESPONSES_SAVE_LOCATION)
    return this_response_df

def add_selected_user_data_to_ingredients(response_df, selected_user_id):
    user_data_df = pd.read_csv(USER_DATA_LOCATION)
    selected_user_df = user_data_df[user_data_df["userId"] == selected_user_id]
    selected_user_df_for_join = selected_user_df[["userId", "userMode", "pregnancyOrPostBirthWeeks"]]
    selected_user_df_for_join.rename(columns={'userMode':'pregnancyStatus'}, inplace=True)
    latest_response_with_user_data = response_df.merge(selected_user_df_for_join, how="cross")
    return latest_response_with_user_data




def compare_new_ingredient_image_response_to_risk_lookup(response_df):
    fda_risk_lookup = pd.read_csv(FDA_INGREDIENT_LOOKUP_LOCATION)
    simple_risks_df = fda_risk_lookup[["additive","riskScore", "riskCategory"]] ## TODO skip this step by preprocessing to this smaller dataset
    simple_risks_df.rename(columns={'additive':'ingredient'}, inplace=True)
    ingredients_with_risks =  response_df.merge(simple_risks_df, how="left", on="ingredient").sort_values("riskScore", ascending = False)
    ingredients_with_risks_json = [ingredients_with_risks.to_json(orient='records', lines=True)]
    return ingredients_with_risks_json


def identify_ingredients_from_text(input_text, client):
    response = client.chat.completions.create(
    model=MODEL,
    messages=[
        {"role": "system", "content": INGREDIENT_TEXT_PROCESSING_SYSTEM_PROMPT},
        {"role": "user", "content": [
            {"type": "text", "text": input_text},
        ]}
    ],
    temperature=0.0,
    )
    return response.choices[0].message.content


def generate_response_from_image_and_user(image, user):
    image = encode_image(image)
    imageIngredientsJson = identify_ingredients_from_label(image, client)
    imageIngredientsDf = process_new_ingredient_image_response(imageIngredientsJson)
    imageIngredientsWithUserDataDf = add_selected_user_data_to_ingredients(imageIngredientsDf, user)
    outputJSON = compare_new_ingredient_image_response_to_risk_lookup(imageIngredientsWithUserDataDf)
    return outputJSON