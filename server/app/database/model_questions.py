from .base import Base
# from .model_users import UserModel
from sqlalchemy import Column, Integer, String, ForeignKey
# from sqlalchemy.orm import relationship

class QuestionModel(Base):
    """Question Model."""

    __tablename__ = "questions"

    id = Column("id", Integer, primary_key=True)
    netid = Column("user_id", String, ForeignKey('user.netid'), nullable=False)
<<<<<<< HEAD
    course_id = Column("course_id", Integer, ForeignKey('course.course_id'), nullable=False)
=======
    course_id = Column("course_id", String, nullable=False)
>>>>>>> c983e7511fd9dad41c1dedb3a62619debd399662
    time_posted = Column("time_posted", String)
    time_started = Column("time_started", String)
    time_completed = Column("time_completed", String)
    question_topic = Column("question_topic", String)
    queue_pos = Column("queue_pos", Integer)
    zoom_link = Column("zoom_link", String)
