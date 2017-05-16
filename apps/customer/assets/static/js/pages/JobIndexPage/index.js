import React, { Component } from 'react';
import Helmet from 'react-helmet';
import styles from './styles.css';
import {
  JobIndexContainer,
} from 'containers';

class JobIndexPage extends Component {

  constructor(props) {
    super(props);
  }
  render() {
    return (
      <article className={styles.container}>
        <Helmet title="Home" />
        <JobIndexContainer />
      </article>
    );
  }

}

export default JobIndexPage;
