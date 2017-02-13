import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer,
  JobIndexContainer
} from 'containers';

function JobIndexPage() {

  return (
    <div className={styles.container}>
      <HeaderContainer />
      <JobIndexContainer />
    </div>
  )

}

export default JobIndexPage;
