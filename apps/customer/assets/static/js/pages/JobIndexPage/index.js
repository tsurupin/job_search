import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  JobIndexContainer
} from 'containers';

class JobIndexPage extends Component {

  constructor(props) {
    super(props)
  }
  render() {
    return (
      <div className={styles.container}>
        <JobIndexContainer />
      </div>
    )
  }

}

export default JobIndexPage;
