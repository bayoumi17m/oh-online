import React from 'react';
import Card from '@material-ui/core/Card';
import Container from '@material-ui/core/Container';
import Grid from '@material-ui/core/Grid';
import Divider from '@material-ui/core/Divider';
import createHistory from 'history/createBrowserHistory';
import { CardActionArea, CardContent } from '@material-ui/core';


import Typography from '@material-ui/core/Typography';

import styles from './environment.module.css';
import data from './Student';

import {
  Link
} from "react-router-dom";


/* Body of Home Page, Creates Necessary Cards */
let history = createHistory();

export default function Classes() {
  const classList = data.Courses
  function Refresh(course) {
    history.push(course)
    history.go(0);
  }

  return (
    <Container maxWidth="lg" className={styles.container}>
      <Typography component="p" variant="h4">
        Active Courses
            </Typography>
      <Divider orientation="horizontal" variant="fullWidth" />
      <Grid container spacing={1} xs={12}>
        {classList.map(course => {
          const url = course.split(' ').join('');
          return (
            < Grid item spacing={3} xs={4} >
              <div className={styles.cards}>
                <Link className={styles.links} onClick={() => Refresh(url)} to={{ pathname: url }} >
                  <ClassCard class={course} />
                </Link>
              </div>
            </Grid>
          );
        })}
        <Grid item spacing={3} xs={4} >
          <div className={styles.cards}>
            <AddClass />
          </div>
        </Grid>
      </Grid>
      <Typography component="p" variant="h4">
        Inactive Courses
            </Typography>
      <Divider orientation="horizontal" variant="fullWidth" />
    </Container>
  );
}

/* Generates Class Card Based on Data */

function ClassCard(props) {
  return (
    <React.Fragment>
      <Card variant="outlined" className={styles.card}>
        <CardActionArea >
          <CardContent className={styles.alignment}>
            <Typography>{props.class}</Typography>
            <Typography color="textSecondary">
              Spring 2020
            </Typography>
            <Typography color="textSecondary">
              Enrolled as Student
      </Typography>
          </CardContent>
        </CardActionArea>
      </Card>
    </React.Fragment >
  );
}

/* Static Add Class Option */
const AddClass = () => {

  return (
    <React.Fragment>
      <Card variant="outlined" className={styles.card}>
        <CardActionArea>
          <CardContent className={styles.alignment}>
            <Typography>Click to Add a Course</Typography>
          </CardContent>
        </CardActionArea>
      </Card>
    </React.Fragment>
  );
}
