import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer
} from 'containers';

class IndexPage extends Component {

  render() {
    return (
      <div className={styles.container}>
        <HeaderContainer />
      </div>
    )
  }
}

export default IndexPage;
