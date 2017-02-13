import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer,
  JobIndexContainer
} from 'containers';

function JobShowPage() {

  return (
    <div className={styles.container}>
      <HeaderContainer />
      <JobShowContainer />
    </div>
  )

}

export default JobShowPage;
