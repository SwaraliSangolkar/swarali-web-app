from flask import Flask, request

app = Flask(__name__)

# Home page with input form
@app.route("/")
def home():
    return '''
        <h2>Enter your name 👇</h2>
        <form action="/greet" method="post">
            <input type="text" name="username" placeholder="Enter name">
            <button type="submit">Submit</button>
        </form>
    '''

# Handle form submission
@app.route("/greet", methods=["POST"])
def greet():
    name = request.form.get("username")
    return f"<h1>Hello {name} </h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)