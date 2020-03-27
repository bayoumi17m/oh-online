from flask import Flask, render_template

app = Flask(__name__)

from yourapplication.database import db_session

@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()

# @app.route('/')
# def home():
#   return render_template('home.html')

@app.route('/queue/<int:queue_id>')
def queue():
  pass

@app.route('/course/<int:course_id>', methods=['GET', 'POST'])
def course():
  if request.method == 'GET':
     return logic.get_queues(course_id)

if __name__ == '__main__':
  app.run(debug=True)