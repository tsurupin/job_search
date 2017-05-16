import React, { Component } from 'react';
import Helmet from 'react-helmet';
import styles from './styles.css';
import {
  JobShowContainer,
} from 'containers';


class JobShowPage extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className={styles.container}>
        <Helmet title="Detail" />
        <JobShowContainer id={this.props.params.id} />
      </div>
    );
  }

}

export default JobShowPage;
