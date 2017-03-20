import React, { PropTypes, Component } from 'react';

import {

  FavoriteJobIndexContainer
} from 'containers';

class FavoriteJobIndexPage extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <article>
        <FavoriteJobIndexContainer />
      </article>
    )

  }
}

export default FavoriteJobIndexPage