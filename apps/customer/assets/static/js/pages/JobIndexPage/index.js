import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer,
  JobIndexContainer
} from 'containers';

class JobIndexPage extends Component {

  constructor(props) {
    super(props)
  }
  render() {
    return (
      <div className={styles.container}>
        <HeaderContainer />
        <JobIndexContainer />
      </div>
    )
  }

}

export default JobIndexPage;
