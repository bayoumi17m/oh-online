"""Model of Users and Courses"""

from .base import Base
from .model_questions import QuestionModel
from sqlalchemy import Table, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

association_table = Table('association_table',
    Base.metadata,
    Column('course_id', Integer, ForeignKey('course.course_id')),
    Column('user_id', String, ForeignKey('user.netid'))
)

class UserModel(Base):
    """User model."""

    __tablename__ = 'user'
    
    id = Column("id", Integer, primary_key=True)
    netid = Column("netid", String, unique=True, nullable=False)
    ta_course_id = Column("ta_course_id", Integer, ForeignKey("course.course_id"), nullable=True)
    zoom_link = Column("zoom_link", String, nullable=True)
    courses = Column("courses", String, nullable=True) #relationship("CourseModel", secondary=association_table, backref="students")
    questionList = relationship("QuestionModel", backref="user")


class CourseModel(Base):
    """Course model."""

    __tablename__ = 'course'
    
    id = Column("id", Integer, primary_key=True)
    course_id = Column("course_id", Integer, unique=True, nullable=False)
    course_name = Column("course_name", String, nullable=False)
    # students = relationship("UserModel", secondary=association_table, back_populates="courses")
    teaching_assistants = relationship("UserModel", backref="course")