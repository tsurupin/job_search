import React, { Component, PropTypes } from 'react';
import { CurrentJobFilterItem } from 'components';

const propTypes = {
  items: PropTypes.array.isRequired,
  handleReset: PropTypes.func.isRequired
};

class CurrentJobFilterBox extends Component {
  constructor(props) {
    super(props);
  }

  handleReset(key) {
    this.prop.handleReset(key);
  }

  render() {
    const { items, handleReset } = this.props;

    return(
      <section className='root'>
        {items.map((item, index) => {
          return(
            <CurrentJobFilterItem
              key={index}
              name={item.key}
              value={item.value}
              handleReset={handleReset()}
            />
          );
        })}
      </section>
    )
  }
}

CurrentJobFilterBox.propTypes = propTypes;
export default CurrentJobFilterBox;
