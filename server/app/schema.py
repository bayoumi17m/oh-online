"""GraphQL Schema Module"""

from datetime import datetime
import graphene
from graphene_sqlalchemy import SQLAlchemyObjectType, SQLAlchemyConnectionField

from database.model_questions import QuestionModel
from database.model_users import UserModel, CourseModel
from database.base import db_session
import utils
from rx import Observable
import rx

from schemas.schema_user import (
    User,
    CreateUser,
    UpdateUser,
    Course
)
from schemas.schema_question import (
    Question,
    CreateQuestion,
    UpdateQuestion,
    RemoveQuestion
)

import logging
logger = logging.getLogger("TestLogger")


class Query(graphene.ObjectType):
    """Query objects with GraphQL API."""

    node = graphene.relay.Node.Field()
    # Get user by unique ID
    user = graphene.relay.Node.Field(User)
    # List all users (w/ Pagination) -> Similar to /users route
    userList = SQLAlchemyConnectionField(User)
    # Get question by unique ID
    question = graphene.relay.Node.Field(Question)
    # List all questions (w/ Pagination) -> Similar to /requests route
    questionList = SQLAlchemyConnectionField(Question)
    # Get user by netid
    user_netid = graphene.Field(User, netid=graphene.String(required=True))
    # check queue pos by user id -> Similar to /check_pos/<int:user_id>
    queue_pos = graphene.Field(graphene.Int, netid=graphene.String(required=True), course_id=graphene.Int(required=True))
    # check entire course queue -> Similar to /requests/<int:course_id>
    course_queue = graphene.List(Question, course_id=graphene.Int(required=True), active=graphene.Boolean(required=False, default_value=True))

    course_name_id = graphene.Field(graphene.Int, course_name=graphene.String(required=True))


    def resolve_user_netid(self, info, netid):
        """Find users by netid"""
        query = User.get_query(info=info)
        query = query.filter(UserModel.netid == netid)
        user = query.first()
    
        return user
    

    def resolve_queue_pos(self, info, netid, course_id):
        """Find queue pos based on netid"""
        query = User.get_query(info=info)
        query = query.filter(
            QuestionModel.netid == netid
            ).filter(
                QuestionModel.queue_pos != -1
                ).filter(
                    QuestionModel.course_id == course_id
                ).with_entities(
                    QuestionModel.queue_pos
                    )

        pos = query.first()[0] if query.first() else -2

        return pos


    def resolve_course_queue(self, info, course_id, active):
        """List of all questions in  course"""
        query = Question.get_query(info=info)
        query = query.filter(QuestionModel.course_id == course_id)

        if active:
            query = query.filter(QuestionModel.queue_pos >= 0)
        
        return query.all()
    

    def resolve_course_name_id(self, info, course_name):
        """Course id from a name"""
        query = Course.get_query(info=info)
        query = query.filter(CourseModel.course_name == course_name).with_entities(CourseModel.course_id)
        res = query.first()[0] if query.first() else 0

        return res


class Mutation(graphene.ObjectType):
    create_user = CreateUser.Field()
    update_user = UpdateUser.Field()
    create_question = CreateQuestion.Field()
    update_question = UpdateQuestion.Field()


class Subscription(graphene.ObjectType):
    queue_len = graphene.Int(course_id=graphene.String())
    count_seconds = graphene.Int(up_to=graphene.Int())
    

    def resolve_queue_len(self, info, course_id):
        course_id = Course.get_query(info=info).filter(
            CourseModel.course_name == course_id
        ).with_entities(CourseModel.course_id).first()[0]
        return Observable.interval(1000)\
                         .map(lambda i: "{0}".format(
                                len(Question.get_query(info = info).filter(
                                        QuestionModel.course_id == course_id
                                    ).filter(
                                        QuestionModel.queue_pos > 0
                                    ).all()
                                )
                        )).take_while(lambda i: True)

    
    def resolve_count_seconds(self, info, up_to):
        return Observable.interval(1000)\
                         .map(lambda i: "{0}".format(i))\
                         .take_while(lambda i: int(i) <= up_to)

