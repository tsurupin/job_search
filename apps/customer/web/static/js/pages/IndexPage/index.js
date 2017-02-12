import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer
} from 'containers';

function IndexPage() {

  return (
    <div className={styles.container}>
      <HeaderContainer />
    </div>
  )

}

export default IndexPage;
