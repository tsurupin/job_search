import React, { Component } from 'react';
import Helmet from 'react-helmet';
import {
  JobShowContainer,
} from 'containers';


class JobShowPage extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Helmet title="Detail" />
        <JobShowContainer id={this.props.params.id} />
      </div>
    );
  }

}

export default JobShowPage;
