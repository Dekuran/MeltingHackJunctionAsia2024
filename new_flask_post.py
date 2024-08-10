from flask import Flask, redirect, url_for, render_template_string, request

app = Flask(__name__)

# HTML template to display the message
html_template = '''
<!doctype html>
<html lang="en">
  <head>
    <title>Display Text</title>
  </head>
  <body>
        <h1>{{ content }}</h1>
  </body>
</html>
'''

app_state = {
    'data': 'Initial Data'
}

@app.route("/", methods=["POST", "GET"])
def home():
    if request.method == "POST":
        app_state['data'] = request.form['data']
    return render_template_string(html_template, content= app_state['data'])

if __name__ == "__main__":
    app.run(debug=True)